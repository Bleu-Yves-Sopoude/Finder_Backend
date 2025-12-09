class BusinessesController < ApplicationController
  before_action :authorize_request, only: [:create, :update, :destroy]
  before_action :require_admin, only: [:create, :update, :destroy]

  include Rails.application.routes.url_helpers

  def index
    businesses = Business.includes(:reviews, :photos_attachments).all

    render json: businesses.map { |b|
      {
        id: b.id,
        name: b.name,
        category: b.category,
        address: b.address,
        average_rating: b.reviews.average(:rating)&.round(1),
        photos: b.photos.map { |p| url_for(p) }   # ⬅️ ADD PHOTO URLs
      }
    }
  end

  def show
    business = Business.includes(reviews: :user).find(params[:id])
    average_rating = business.reviews.average(:rating)&.round(1)

    render json: {
      id: business.id,
      name: business.name,
      description: business.description,
      address: business.address,
      category: business.category,
      average_rating: average_rating,
      photos: business.photos.map { |p| url_for(p) }, # ⬅️ PHOTO URLs
      reviews: business.reviews.map do |review|
        {
          id: review.id,
          rating: review.rating,
          comment: review.comment,
          created_at: review.created_at,
          user: {
            id: review.user.id,
            name: review.user.name
          }
        }
      end
    }
  end

  def create
    business = Business.new(business_params)

    if business.save
      render json: { message: "Business created successfully", id: business.id }, status: :created
    else
      render json: { errors: business.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Only admins allowed to create/update/delete
  def require_admin
    unless @current_user&.is_admin?
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  def business_params
    params.require(:business).permit(
      :name,
      :description,
      :address,
      :category,
      photos: []         # ⬅️ IMPORTANT: Only admins can send photos
    )
  end
end
