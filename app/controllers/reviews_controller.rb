class ReviewsController < ApplicationController
  before_action :authorize_request
  before_action :set_business

  # GET /businesses/:business_id/reviews
  def index
    reviews = @business.reviews.includes(:user).order(created_at: :desc)

    render json: reviews.map { |review|
      review.as_json(
        include: { user: { only: [:id, :name, :email] } },
        only: [:id, :rating, :comment, :created_at]
      ).merge(
        photos: review.photos.map { |p| url_for(p) }
      )
    }
  end

  # GET /businesses/:business_id/reviews/:id
  def show
    review = @business.reviews.includes(:user).find(params[:id])

    render json: review.as_json(
      include: { user: { only: [:id, :name, :email] } },
      only: [:id, :rating, :comment, :created_at]
    ).merge(
      photos: review.photos.map { |p| url_for(p) }
    )
  end

  # POST /businesses/:business_id/reviews
  def create
    review = @business.reviews.build(review_params)
    review.user = current_user

    if review.save
      render json: review.as_json(
        include: { user: { only: [:id, :name, :email] } },
        only: [:id, :rating, :comment, :created_at]
      ).merge(
        photos: review.photos.map { |p| url_for(p) }
      ), status: :created
    else
      render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_business
    @business = Business.find(params[:business_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, photos: [])
  end
end
