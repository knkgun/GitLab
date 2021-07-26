import initRelatedFeatureFlags from 'ee/related_feature_flags';
import initSidebarBundle from 'ee/sidebar/sidebar_bundle';

import DesignManagement from '~/design_management';
import initShow from '~/pages/projects/issues/show';
import initRelatedIssues from '~/related_issues';
import UserCallout from '~/user_callout';

initShow();
DesignManagement();

window.requestIdleCallback(() => {
  initSidebarBundle();
  initRelatedIssues();
  initRelatedFeatureFlags();
});

// eslint-disable-next-line no-new
new UserCallout({ className: 'js-epics-sidebar-callout' });
// eslint-disable-next-line no-new
new UserCallout({ className: 'js-weight-sidebar-callout' });
