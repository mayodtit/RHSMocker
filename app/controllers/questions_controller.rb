class QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])
    render :template => 'api/v1/questions/show', :locals => {:question => @question}
  end
end
