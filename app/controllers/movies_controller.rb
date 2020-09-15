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
    #Rating filter
    @all_ratings = ['G','PG','PG-13','R']
    if params[:ratings]==nil and session[:ratings]!=nil #reloading when the user was away
      
    elsif params[:ratings]==nil and session[:ratings]==nil #first time with no ratings
      session[:ratings]=@all_ratings
      
    elsif params[:ratings]!=nil and session[:ratings]==nil #first time with ratings
      session[:ratings]=params[:ratings].keys
      
    elsif params[:ratings]!=nil and session[:ratings]!=nil #several times with ratings
      session[:ratings]=params[:ratings].keys
      
    end
    @ratings=session[:ratings]
    @movies=Movie.all.with_ratings(@ratings)
    
    #Sorting
    if params[:sorting_parameter]==nil and session[:sorting_parameter]!=nil #reloading when the user was away
      sorting_parameter=session[:sorting_parameter]
    elsif params[:sorting_parameter]==nil and session[:sorting_parameter]==nil #first time with no sorting
      session[:sorting_parameter]=nil
      
    elsif params[:sorting_parameter]!=nil and session[:sorting_parameter]==nil #first time with sorting
      session[:sorting_parameter]=params[:sorting_parameter]
      
    elsif params[:sorting_parameter]!=nil and session[:sorting_parameter]!=nil #serveral times with sorting
      session[:sorting_parameter]=params[:sorting_parameter]
    
    end
    #This part is changed from the original version to ensure the sorting happens only on the filtered moveis
    sorting_parameter=session[:sorting_parameter]
    if sorting_parameter == 'title'
      @movies = Movie.with_ratings(session[:ratings]).sort_by { |movie| movie.title }
      
    elsif sorting_parameter == 'release_date'
      @movies = Movie.with_ratings(session[:ratings]).sort_by { |movie| movie.release_date }
      
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
