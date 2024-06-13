class ReportsController < ApplicationController
  before_action :authenticate_user!
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @report = Report.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @report = Report.new(report_params)
    @report.user_id = current_user.id
    @report.restaurant_id = @restaurant.id
    if @report.save
      flash[:notice] = "レポの登録に成功しました。投稿ありがとう！"
      redirect_to restaurant_path(@restaurant.id)
    else
      flash[:alert] = "レポの登録に失敗しました。"
      render :new
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:restaurant_id])
    @report = @restaurant.reports.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    if @report.update(report_params)
      flash[:notice] = "レポを更新しました。"
      redirect_to restaurant_path(@report.restaurant.id)
    else
      flash[:alert] = "レポの更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant_reports = @restaurant.reports
    Report.find_by(id: params[:id], restaurant_id: params[:restaurant_id]).destroy
    flash[:notice] = "レポを削除しました。"
    redirect_to restaurant_path(@restaurant.id)
  end

  private

  def report_params
    params.require(:report).permit(:title, :recommend, :memo, :image, :report_id)
  end
end
