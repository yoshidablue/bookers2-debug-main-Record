class SearchesController < ApplicationController

  def search
    # 入力、選択された値をparamsで受け取って＠〜に代入
    # paramsは、フォームなどによって送られてきた情報（パラメーター）を取得するメソッド
    @content = params[:content]  # 検索ワード
    @model = params[:model]      # 選択対象（User、Book）
    @method = params[:method]    # 検索方法(完全一致、前方一致、後方一致、部分一致)
    # 条件分岐
    # @recordsに入れているのは検索結果
    if @model == "user"
      @records = User.search_for(@content, @method)
    else
      @records = Book.search_for(@content, @method)
    end
  end

end
