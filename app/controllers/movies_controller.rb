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
    if params[:ratings].nil?
      if session[:ratings].nil?
        @ratings = Hash[@all_ratings.collect{|rating| [rating, 1]}]
        session[:ratings] = @ratings
      else
        @ratings = session[:ratings]
        redirect = true
      end
    else
      @ratings = params[:ratings]
      session[:ratings] = @ratings
    end
    if params[:sort].nil?
      if session[:sort].nil?
        @sort = nil
      else
        @sort = session[:sort]
        redirect = true
      end
    else
      @sort = params[:sort].to_sym
      session[:sort] = @sort
    end
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
