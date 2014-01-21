class QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])
    render template: 'api/v1/questions/show', locals: {card: nil, question: @question}
  end
end
