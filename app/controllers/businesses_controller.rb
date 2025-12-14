class BusinessesController < ApplicationController
  def index
    businesses = Business.includes(:reviews).all

    render json: businesses.map { |b|
      {
        id: b.id,
        name: b.name,
        category: b.category,
        address: b.address,
        average_rating: b.reviews.average(:rating)&.round(1)
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

  # ✅ DAY 22
  def nearby
    lat = params[:lat]
    lng = params[:lng]
    radius = (params[:radius] || 5).to_f

    return render json: { error: "lat and lng are required" }, status: :bad_request if lat.blank? || lng.blank?

    businesses = Business
      .near([lat, lng], radius)
      .includes(:reviews)

    render json: businesses.map { |b|
      {
        id: b.id,
        name: b.name,
        category: b.category,
        address: b.address,
        average_rating: b.reviews.average(:rating)&.round(1),
        distance: b.distance.round(2)
      }
    }
  end
end
