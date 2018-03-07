module EffectiveTrashHelper

  def render_trash(trash)
    render(partial: 'effective/trash/trash', locals: { trash: trash })
  end

end
