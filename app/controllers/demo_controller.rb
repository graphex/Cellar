class DemoController < ActionController::Base

  def queue_item
    ItemQueue.perform_async(params[:item])
    render :text => "OK\n"
  end
end
