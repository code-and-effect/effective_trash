EffectiveTrash::Engine.routes.draw do
  scope :module => 'effective' do

    if EffectiveTrash.routes_enabled
      resources :trash, only: [:index, :show] do
        member { get :restore }
      end
    end
  end

  if EffectiveTrash.routes_enabled
    namespace :admin do
      resources :trash, only: [:index, :show]
    end
  end

end

Rails.application.routes.draw do
  mount EffectiveTrash::Engine => '/', :as => 'effective_trash'
end
