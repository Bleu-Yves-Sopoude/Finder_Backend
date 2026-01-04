class BusinessesController < ApplicationController
  before_action :authorize_request, only: [ :create ]
  include Rails.application.routes.url_helpers

  # GET /businesses
  def index
    businesses = Business
      .search(params[:query])
      .with_min_rating(params[:min_rating])

    render json: businesses.map { |b|
      {
        id: b.id,
        name: b.name,
        category: b.category,
        address: b.address,
        average_rating: b.reviews.average(:rating)&.round(1),
        cover_photo: b.photos.attached? ? url_for(b.photos.first) : nil
      }
    }
  end

  # GET /businesses/:id
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
      photos: business.photos.map { |p| url_for(p) },
      cover_image: business.cover_image.attached? ? url_for(business.cover_image) : nil,
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

  # POST /businesses
  def create
    business = current_user.businesses.new(business_params)

    if business.save
      # Attach multiple photos if present
      business.photos.attach(params[:photos]) if params[:photos].present?

      # Optionally set first photo as cover image
      if business.photos.attached? && business.respond_to?(:cover_image)
        business.cover_image.attach(business.photos.first.blob)
      end

      render json: {
        id: business.id,
        name: business.name,
        description: business.description,
        address: business.address,
        category: business.category,
        latitude: business.latitude,
        longitude: business.longitude,
        photos: business.photos.map { |p| url_for(p) },
        cover_image: business.cover_image.attached? ? url_for(business.cover_image) : nil
      }, status: :created
    else
      render json: { errors: business.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /businesses/nearby
  def nearby
    lat = params[:lat]
    lng = params[:lng]
    radius = (params[:radius] || 5).to_f

    if lat.blank? || lng.blank?
      return render json: { error: "lat and lng required" }, status: :bad_request
    end

    businesses = Business
      .near([ lat, lng ], radius)
      .includes(:reviews)
      .search(params[:query])
      .with_min_rating(params[:min_rating])

    render json: businesses.map { |b|
      {
        id: b.id,
        name: b.name,
        category: b.category,
        address: b.address,
        average_rating: b.reviews.average(:rating)&.round(1),
        distance: b.distance.round(2),
        cover_photo: b.photos.attached? ? url_for(b.photos.first) : nil
      }
    }
  end

  private

  # ✅ Permit latitude and longitude here
  def business_params
    params.permit(:name, :description, :address, :category, :latitude, :longitude, photos: [])
  end
end
