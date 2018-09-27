# frozen_string_literal: true

class Api::EventsController < Api::APIController
  def index
    events = Event.active
                  .published
                  .upcoming
    page = params[:page].present? ? params[:page].to_i : 0
    render json: paginate(events, page)
  end

  def create
    event = Event.new(event_params)
    if event.save
      render json: event
    else
      render json: event.errors, status: :bad_request
    end
  end

  def show
    event = Event.find_by_id(params[:id])
    if !event.nil?
      render json: event
    else
      render :nothing, status: :not_found
    end
  end

  def update
    event = Event.find_by_id(params[:id])
    if event.update(event_params)
      render json: event
    else
      render json: event.errors, status: :bad_request
    end
  end

  def destroy
    event = Event.find_by_id(params[:id])
    if !event.nil?
      if event.destroy
        render :nothing, status: :ok
      else
        render :nothing, status: :internal_server_error
      end
    else
      render :nothing, status: :bad_request
    end
  end

  private

  def event_params
    params.permit(
      :non_billig_title_no,
      :title_en,
      :short_description_en,
      :short_description_no,
      :long_description_en,
      :long_description_no,
      :event_type,
      :age_limit,
      :area_id,
      :status,
      :image_id,
      :primary_color,
      :secondary_color,
      :banner_alignment,
      :organizer_type,
      :non_billig_start_time,
      :duration,
      :publication_time,
      :spotify_uri,
      :facebook_link,
      :youtube_link,
      :youtube_embed,
      :soundcloud_link,
      :instagram_link,
      :twitter_link,
      :lastfm_link,
      :vimeo_link,
      :general_link,
      :price_type,
      :billig_event_id,
      :organizer_id,
      :codeword,
      price_groups_attributes: %i(name price id _destroy)
    )
  end
end
