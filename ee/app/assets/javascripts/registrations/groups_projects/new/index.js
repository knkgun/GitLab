import $ from 'jquery';
import { bindHowToImport } from '~/projects/project_new';
import { displayGroupPath, displayProjectPath } from './path_display';
import mountProgressBar from './progress_bar';
import showTooltip from './show_tooltip';

const importButtonsSubmit = () => {
  const buttons = document.querySelectorAll('.js-import-project-buttons a');
  const form = document.querySelector('.js-import-project-form');
  const submit = form.querySelector('input[type="submit"]');
  const importUrlField = form.querySelector('.js-import-url');

  const clickHandler = (e) => {
    e.preventDefault();
    importUrlField.value = e.target.getAttribute('href');
    submit.click();
  };

  buttons.forEach((button) => button.addEventListener('click', clickHandler));
};

const setAutofocus = () => {
  const setInputfocus = () => {
    document
      .querySelector('.js-group-project-tab-contents .tab-pane.active .js-group-name-field')
      ?.focus();
  };

  setInputfocus();

  $('.js-group-project-tabs').on('shown.bs.tab', setInputfocus);
};

export default () => {
  mountProgressBar();
  displayGroupPath('.js-group-path-source', '.js-group-path-display');
  displayGroupPath('.js-import-group-path-source', '.js-import-group-path-display');
  displayProjectPath('.js-project-path-source', '.js-project-path-display');
  showTooltip('.js-group-name-tooltip');
  importButtonsSubmit();
  bindHowToImport();
  setAutofocus();
};
