Rails.application.routes.draw do
  scope(:module => 'refinery') do
    scope(:path => 'blog', :module => 'blog') do
      root :to => 'posts#index', :as => 'blog_root'
      match 'feed.rss', :to => 'posts#index', :as => 'blog_rss_feed', :defaults => {:format => "rss"}
      match ':id', :to => 'posts#show', :as => 'blog_post'
      match 'categories/:id', :to => 'categories#show', :as => 'blog_category'
      match ':id/comments', :to => 'posts#comment', :as => 'blog_post_blog_comments'
      get 'archive/:year(/:month)', :to => 'posts#archive', :as => 'archive_blog_posts'
      get 'tagged/:tag_id(/:tag_name)' => 'posts#tagged', :as => 'tagged_posts'

      scope(:path => 'refinery', :as => 'refinery_admin', :module => 'admin') do
        root :to => 'posts#index'
        resources :posts do
          collection do
            get :uncategorized
            get :tags
          end
        end

        resources :categories

        resources :comments do
          collection do
            get :approved
            get :rejected
          end
          member do
            get :approved
            get :rejected
          end
        end

        resources :settings do
          collection do
            get :notification_recipients
            post :notification_recipients

            get :moderation
            get :comments
            get :teasers
          end
        end
      end
    end
  end
end
