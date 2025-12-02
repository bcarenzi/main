class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy, :export]

  def index
    @movies = Movie.order(watched_at: :desc)
  end

  def show
  end

  def new
    @movie = Movie.new
    @movie.watched_at = Date.today
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to @movie, notice: 'Filme adicionado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to @movie, notice: 'Filme atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_url, notice: 'Filme removido com sucesso!'
  end

  def export
    data = {
      id: @movie.id,
      title: @movie.title,
      watched_at: @movie.watched_at,
      rating: @movie.rating,
      notes: @movie.notes,
      created_at: @movie.created_at,
      updated_at: @movie.updated_at
    }

    send_data data.to_json, 
              filename: "filme_#{@movie.id}_#{@movie.title.parameterize}.json",
              type: 'application/json',
              disposition: 'attachment'
  end

  def export_all
    send_data Movie.export_to_json,
              filename: "cinepass_filmes_#{Date.today.strftime('%Y%m%d')}.json",
              type: 'application/json',
              disposition: 'attachment'
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :watched_at, :rating, :notes)
  end
end

