defmodule RaffleyWeb.RuleHTML do
  use RaffleyWeb, :html

  embed_templates "rule_html/*"

  def show(assigns) do
    ~H"""
    <div class="rules">
      <h1>{@greeting}! Don't Forget...</h1>
      <p>
        {@rule.text}
      </p>
    </div>
    """
  end
end

# embed_templates은 해당 경로에 있는 파일을 전부 아래처럼 함수로 바꿔줌(컴파일 때)
# 그래서 짧은 heex는 이렇게 처음부터 함수로 만들어도 괜찮음
# 컴파일 시점에 함수로 변환되기 때문에 런타임 성능 저하는 없음
