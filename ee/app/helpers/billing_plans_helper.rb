# frozen_string_literal: true

module BillingPlansHelper
  def subscription_plan_info(plans_data, current_plan_code)
    plans_data.find { |plan| plan.code == current_plan_code }
  end

  def number_to_plan_currency(value)
    number_to_currency(value, unit: '$', strip_insignificant_zeros: true, format: "%u%n")
  end

  def subscription_plan_data_attributes(group, plan)
    return {} unless group

    {
      namespace_id: group.id,
      namespace_name: group.name,
      add_seats_href: add_seats_url(group),
      plan_upgrade_href: plan_upgrade_url(group, plan),
      plan_renew_href: plan_renew_url(group),
      customer_portal_url: "#{EE::SUBSCRIPTIONS_URL}/subscriptions",
      billable_seats_href: billable_seats_href(group)
    }
  end

  def use_new_purchase_flow?(namespace)
    namespace.group? && (namespace.actual_plan_name == Plan::FREE || namespace.trial_active?)
  end

  def show_contact_sales_button?(purchase_link_action)
    experiment_enabled?(:contact_sales_btn_in_app) &&
      purchase_link_action == 'upgrade'
  end

  def experiment_tracking_data_for_button_click(button_label)
    return {} unless Gitlab::Experimentation.active?(:contact_sales_btn_in_app)

    {
      track: {
        event: 'click_button',
        label: button_label,
        property: experiment_tracking_category_and_group(:contact_sales_btn_in_app)
      }
    }
  end

  def plan_feature_short_list(plan)
    return [] unless plan.features

    plan.features.sort_by! { |feature| feature.highlight ? 0 : 1 }[0...4]
  end

  def plan_purchase_or_upgrade_url(group, plan)
    if group.upgradable?
      plan_upgrade_url(group, plan)
    else
      plan_purchase_url(group, plan)
    end
  end

  def show_plans?(namespace)
    namespace.trial_active? || !namespace.gold_plan?
  end

  def show_trial_banner?(namespace)
    return false unless params[:trial]

    root = namespace.has_parent? ? namespace.root_ancestor : namespace
    root.trial_active?
  end

  def namespace_for_user?(namespace)
    namespace == current_user.namespace
  end

  def seats_data_last_update_info
    last_enqueue_time = UpdateMaxSeatsUsedForGitlabComSubscriptionsWorker.last_enqueue_time&.utc
    return _("Seats usage data as of %{last_enqueue_time} (Updated daily)" % { last_enqueue_time: last_enqueue_time }) if last_enqueue_time

    _('Seats usage data is updated every day at 12:00pm UTC')
  end

  def upgrade_button_css_classes(namespace, plan, is_current_plan)
    css_classes = %w[btn btn-success gl-button]

    css_classes << 'disabled' if is_current_plan && !namespace.trial_active?
    css_classes << 'invisible' if plan.deprecated?

    css_classes.join(' ')
  end

  def available_plans(plans_data, current_plan)
    return plans_data unless ::Feature.enabled?(:hide_deprecated_billing_plans)

    plans_data.filter { |plan_data| !plan_data.deprecated? || plan_data.code == current_plan&.code }
  end

  private

  def add_seats_url(group)
    return unless group

    "#{EE::SUBSCRIPTIONS_URL}/gitlab/namespaces/#{group.id}/extra_seats"
  end

  def plan_purchase_url(group, plan)
    if use_new_purchase_flow?(group)
      new_subscriptions_path(plan_id: plan.id, namespace_id: group.id)
    else
      "#{plan.purchase_link.href}&gl_namespace_id=#{group.id}"
    end
  end

  def plan_upgrade_url(group, plan)
    return unless group && plan&.id

    "#{EE::SUBSCRIPTIONS_URL}/gitlab/namespaces/#{group.id}/upgrade/#{plan.id}"
  end

  def plan_renew_url(group)
    return unless group

    "#{EE::SUBSCRIPTIONS_URL}/gitlab/namespaces/#{group.id}/renew"
  end

  def billable_seats_href(group)
    return unless Feature.enabled?(:api_billable_member_list, group)

    group_seat_usage_path(group)
  end
end
