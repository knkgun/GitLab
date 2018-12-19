/* eslint-disable no-new */

import $ from 'jquery';
import GLForm from '~/gl_form';
import IssuableForm from '~/issuable_form';
import LabelsSelect from '~/labels_select';
import MilestoneSelect from '~/milestone_select';
import ShortcutsNavigation from '~/behaviors/shortcuts/shortcuts_navigation';
import IssuableTemplateSelectors from '~/templates/issuable_template_selectors';
import initSuggestions from '~/issuable_suggestions';
import WeightSelect from 'ee/weight_select';

export default () => {
  new ShortcutsNavigation();
  new GLForm($('.issue-form'));
  new IssuableForm($('.issue-form'));
  new LabelsSelect();
  new MilestoneSelect();
  new IssuableTemplateSelectors();

  if (gon.features.graphql) {
    initSuggestions();
  }

  new WeightSelect();
};
