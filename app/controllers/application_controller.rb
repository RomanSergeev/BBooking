class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(user)
    user_path(user)
  end

  def search
    params[:q] ||= ''
    query = "to_tsquery('" + params[:q] + "')"
    @records = Service.find_by_sql(
      "SELECT id, servicedata, ts_headline(textsearchable_index_col, " + query +
        ") as tooltip FROM services WHERE to_tsvector(textsearchable_index_col) @@ " + query + ";"
    )
    render 'search/index', layout: 'search'
  end

end
