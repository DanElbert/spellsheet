Spellsheet::Application.routes.draw do

  resources :libraries do
    member do
      get 'spell_sheet', :defaults => { :format => "pdf" }
      post 'memorize_spell'
      post 'cast_spell'
    end
  end

  resources :spell_books, :except => [:new, :index] do
    member do
      post 'toggle_learned'
      post 'list_spells'
      post 'add_spell'
      delete 'remove_spell'
    end
  end
  
  match '/spell_book/new(.:format)' => 'spell_books#new', :as => 'new_spell_book', :via => :post, :defaults => { :format => "html" }

  resources :spells, :except => [:destroy]
  
  root :to => 'libraries#index'
end
