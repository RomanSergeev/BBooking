class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(user)
    user_path(user)
  end

  def search
    # TODO make some universal query preparator
    param = params[:q] || ''
    param.delete!('&')
    param.delete!('|')
    param.squeeze!(' ')
    param.strip!
    param.gsub!(' ', ' | ')
    # single-quotes are essential for correct PostgreSQL ts_query
    query = 'to_tsquery(\'' + param + '\')'
    @records = Service.find_by_sql(
      'SELECT * FROM (' +
        'SELECT ' +
          'services.id AS id, ' +
          'services.user_id, ' +
          'services.servicedata, ' +
          'ts_headline(textsearchable_index_col, ' + query + ') AS tooltip, ' +
          'profiles.personaldata AS userdata, ' +
          'ts_rank_cd(to_tsvector(textsearchable_index_col), ' + query + ') AS rank ' +
        'FROM services JOIN profiles ON services.user_id = profiles.user_id ' +
      ') t ' +
      'WHERE t.rank > 0 ' +
      'ORDER BY t.rank desc;'
    )
    render 'search/index', layout: 'search'
  end

end
