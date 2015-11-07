class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    @all_ratings = Movie.all_ratings
    if params[:ratings].nil?
      @filter = Hash[@all_ratings.collect{|rating| [rating, true]}] 
    else
      @filter = Hash[params[:ratings].keys.collect{|rating| [rating, true]}]
    end
    if params[:sort] == 'title'
      @sort_column = :title
      @movies = Movie.all.order(:title)
    elsif params[:sort] == 'release_date'
      @sort_column = :release_date
      @movies = Movie.all.order(:release_date)
    else
      @sort_column = nil
      @movies = Movie.all.where rating: @filter.keys
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
