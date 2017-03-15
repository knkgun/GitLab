export const environmentsList = [
  {
    name: 'DEV',
    size: 1,
    id: 7,
    state: 'available',
    external_url: null,
    environment_type: null,
    last_deployment: null,
    'stop_action?': false,
    environment_path: '/root/review-app/environments/7',
    stop_path: '/root/review-app/environments/7/stop',
    created_at: '2017-01-31T10:53:46.894Z',
    updated_at: '2017-01-31T10:53:46.894Z',
    rollout_status_path: '/path',
  },
  {
    folderName: 'build',
    size: 5,
    id: 12,
    name: 'build/update-README',
    state: 'available',
    external_url: null,
    environment_type: 'build',
    last_deployment: null,
    'stop_action?': false,
    environment_path: '/root/review-app/environments/12',
    stop_path: '/root/review-app/environments/12/stop',
    created_at: '2017-02-01T19:42:18.400Z',
    updated_at: '2017-02-01T19:42:18.400Z',
  },
];

export const serverData = [
  {
    name: 'DEV',
    size: 1,
    latest: {
      id: 7,
      name: 'DEV',
      state: 'available',
      external_url: null,
      environment_type: null,
      last_deployment: null,
      'stop_action?': false,
      environment_path: '/root/review-app/environments/7',
      stop_path: '/root/review-app/environments/7/stop',
      created_at: '2017-01-31T10:53:46.894Z',
      updated_at: '2017-01-31T10:53:46.894Z',
    },
  },
  {
    name: 'build',
    size: 5,
    latest: {
      id: 12,
      name: 'build/update-README',
      state: 'available',
      external_url: null,
      environment_type: 'build',
      last_deployment: null,
      'stop_action?': false,
      environment_path: '/root/review-app/environments/12',
      stop_path: '/root/review-app/environments/12/stop',
      created_at: '2017-02-01T19:42:18.400Z',
      updated_at: '2017-02-01T19:42:18.400Z',
    },
  },
];

export const environment = {
  name: 'DEV',
  size: 1,
  latest: {
    id: 7,
    name: 'DEV',
    state: 'available',
    external_url: null,
    environment_type: null,
    last_deployment: null,
    'stop_action?': false,
    environment_path: '/root/review-app/environments/7',
    stop_path: '/root/review-app/environments/7/stop',
    created_at: '2017-01-31T10:53:46.894Z',
    updated_at: '2017-01-31T10:53:46.894Z',
    rollout_status_path: '/path',
  },
};
<<<<<<< HEAD

const deployBoardMockData = {
  instances: [
    { status: 'finished', tooltip: 'tanuki-2334 Finished' },
    { status: 'finished', tooltip: 'tanuki-2335 Finished' },
    { status: 'finished', tooltip: 'tanuki-2336 Finished' },
    { status: 'finished', tooltip: 'tanuki-2337 Finished' },
    { status: 'finished', tooltip: 'tanuki-2338 Finished' },
    { status: 'finished', tooltip: 'tanuki-2339 Finished' },
    { status: 'finished', tooltip: 'tanuki-2340 Finished' },
    { status: 'finished', tooltip: 'tanuki-2334 Finished' },
    { status: 'finished', tooltip: 'tanuki-2335 Finished' },
    { status: 'finished', tooltip: 'tanuki-2336 Finished' },
    { status: 'finished', tooltip: 'tanuki-2337 Finished' },
    { status: 'finished', tooltip: 'tanuki-2338 Finished' },
    { status: 'finished', tooltip: 'tanuki-2339 Finished' },
    { status: 'finished', tooltip: 'tanuki-2340 Finished' },
    { status: 'deploying', tooltip: 'tanuki-2341 Deploying' },
    { status: 'deploying', tooltip: 'tanuki-2342 Deploying' },
    { status: 'deploying', tooltip: 'tanuki-2343 Deploying' },
    { status: 'failed', tooltip: 'tanuki-2344 Failed' },
    { status: 'ready', tooltip: 'tanuki-2345 Ready' },
    { status: 'ready', tooltip: 'tanuki-2346 Ready' },
    { status: 'preparing', tooltip: 'tanuki-2348 Preparing' },
    { status: 'preparing', tooltip: 'tanuki-2349 Preparing' },
    { status: 'preparing', tooltip: 'tanuki-2350 Preparing' },
    { status: 'preparing', tooltip: 'tanuki-2353 Preparing' },
    { status: 'waiting', tooltip: 'tanuki-2354 Waiting' },
    { status: 'waiting', tooltip: 'tanuki-2355 Waiting' },
    { status: 'waiting', tooltip: 'tanuki-2356 Waiting' },
  ],
  abort_url: 'url',
  rollback_url: 'url',
  completion: 100,
  valid: true,
};

const invalidDeployBoardMockData = {
  instances: [],
  abort_url: 'url',
  rollback_url: 'url',
  completion: 100,
  valid: false,
};

module.exports = {
  environmentsList,
  environment,
  serverData,
  deployBoardMockData,
  invalidDeployBoardMockData,
};
=======
>>>>>>> ce/master
