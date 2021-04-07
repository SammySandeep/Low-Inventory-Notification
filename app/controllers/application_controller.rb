class ApplicationController < ActionController::Base
    after_action :allow_shopify_iframe
    private

    def allow_shopify_iframe
        response.headers['X-Frame-Options'] = 'ALLOWALL'
    end

    def current_shop
        Shop.find_by_shopify_domain(session['shopify.omniauth_params']['shop'])
    end

    def shop_setting_created?
        is_created = find_shop_id_in_shop_setting(current_shop.id)
        if !is_created
            redirect_to new_shop_setting_path
        end
    end

    def find_shop_id_in_shop_setting(shop_id)
        ShopSetting.exists? shop_id: shop_id
    end

end
