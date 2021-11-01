import Vue from 'vue';
import VueApollo from 'vue-apollo';
import { ITEM_TYPE } from '~/groups/constants';
import createDefaultClient from '~/lib/graphql';
import { getParameterValues } from '~/lib/utils/url_utility';
import { extractFilterQueryParameters } from '~/analytics/shared/utils';
import MergeRequestAnalyticsApp from './components/app.vue';
import createStore from './store';
import { parseAndValidateDates } from './utils';

Vue.use(VueApollo);

const apolloProvider = new VueApollo({
  defaultClient: createDefaultClient({}, { assumeImmutableResults: true }),
});

export default () => {
  const el = document.querySelector('#js-merge-request-analytics-app');

  if (!el) return false;

  const { type, fullPath, milestonePath, labelsPath } = el.dataset;
  const store = createStore();

  store.dispatch('filters/setEndpoints', {
    milestonesEndpoint: milestonePath,
    labelsEndpoint: labelsPath,
    groupEndpoint: type === ITEM_TYPE.GROUP ? fullPath : null,
    projectEndpoint: type === ITEM_TYPE.PROJECT ? fullPath : null,
  });

  const {
    selectedSourceBranch,
    selectedTargetBranch,
    selectedAssignee,
    selectedAuthor,
    selectedMilestone,
    selectedLabelList,
  } = extractFilterQueryParameters(window.location.search);

  store.dispatch('filters/initialize', {
    selectedSourceBranch,
    selectedTargetBranch,
    selectedAssignee,
    selectedAuthor,
    selectedMilestone,
    selectedLabelList,
  });

  const { startDate, endDate } = parseAndValidateDates(
    getParameterValues('start_date'),
    getParameterValues('end_date'),
  );

  return new Vue({
    el,
    apolloProvider,
    store,
    name: 'MergeRequestAnalyticsApp',
    provide: {
      fullPath,
      type,
    },
    render: (createElement) =>
      createElement(MergeRequestAnalyticsApp, {
        props: {
          startDate,
          endDate,
        },
      }),
  });
};
