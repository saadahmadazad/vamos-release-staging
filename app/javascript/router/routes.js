import LayoutSystem from '@/layout/LayoutSystem'
import LayoutDefault from '@/layout/LayoutDefault'

export default [{
    // Blank layout
    path: '/auth',
    component: LayoutDefault,
    meta: {auth: false},
    children: [{
      path: 'sign_in',
      name: 'signIn',
      component: () => import('@/pages/Auth/SignIn/index.vue'),
    },
    { path: 'sign_up',
      name: 'signUp',
      component: () => import('@/pages/Auth/SignUp/index.vue'),
    },
    { path: 'forget_password',
      name: 'forget',
      component: () => import('@/pages/Auth/PasswordForget/index.vue'),
    }]
  }, {
    path: '/system',
    component: LayoutSystem,
    meta: {auth: true},
    children: [{
      path: 'dashboard',
      name: 'dashboard',
      component: () => import('@/pages/Dashboard/index.vue'),
    },
    { path: 'room',
      name: 'room',
      component: () => import('@/pages/Room/index.vue'),
    },
    { path: 'facility',
      name: 'facility',
      component: () => import('@/pages/Facility/index.vue'),
    },
    { path: 'ota',
      name: 'ota',
      component: () => import('@/pages/OTA/index.vue'),
    },
    { path: 'other/qa',
      name: 'qa',
      component: () => import('@/pages/Other/QA/index.vue'),
    },
    { path: 'user',
      name: 'user',
      component: () => import('@/pages/User/index.vue'),
    }
  ]
}]

