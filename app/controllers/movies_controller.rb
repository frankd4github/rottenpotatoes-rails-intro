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
    # debugger
    @all_ratings = Movie.all_ratings
    redirect = false
    @ratings = params[:ratings] || 
      session[:ratings] ||
      Hash[@all_ratings.collect{|rating| [rating, 1]}]
    redirect ||= params[:ratings].nil? && ! session[:ratings].nil?
    session[:ratings] = @ratings
    
    @sort = params[:sort] ||
      session[:sort] ||
      nil
    redirect ||= params[:sort].nil? && ! session[:sort].nil?
    session[:sort] = @sort
    
    if redirect
      redirect_to movies_path(ratings: @ratings, sort: @sort)
    else
      @movies = Movie.all.order(@sort).where rating: @ratings.keys
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
