class ReportsController < ApplicationController
  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @report = Report.new(report_params)
    @report.user_id = current_user.id
    @report.restaurant_id = @restaurant.id
    if @report.save
      flash[:notice] = "レポートの登録に成功しました。投稿ありがとう！"
      redirect_to restaurant_path(@restaurant.id)
    else
      flash.now[:alert] = "登録に失敗しました。「このお店のレポを書く」ボタンを押して、フォームを再度確認してください。"
      render 'restaurants/show'
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:restaurant_id])
    @report = @restaurant.reports.find(params[:id])
  end

  def update
    report = Report.find(params[:id])
    report.update(report_params)
    redirect_to restaurant_path(report.restaurant.id)
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant_reports = @restaurant.reports
    Report.find_by(id: params[:id], restaurant_id: params[:restaurant_id]).destroy
    redirect_to restaurant_path(@restaurant.id)
  end

  private

  def report_params
    params.require(:report).permit(:title, :recommend, :memo, :image, :report_id)
  end
end
