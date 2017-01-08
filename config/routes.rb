EffectiveTrash::Engine.routes.draw do
  scope :module => 'effective'
    if EffectiveTrash.trash_enabled
      resources :trash, only: [:index, :show] do
        member { get :restore }
      end
    end
  end

  if EffectiveTrash.trash_enabled
    namespace :admin do
      resources :trash, only: [:index, :show]
    end
  end

end

Rails.application.routes.draw do
  mount EffectiveTrash::Engine => '/', :as => 'effective_trash'
end
