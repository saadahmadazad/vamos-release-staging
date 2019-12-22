<template>
  <el-card class="box-card">
    <div slot="header" class="clearfix">
      <span>会員ログイン</span>
    </div>
    <div>
      <el-form label-width="100px" class="demo-ruleForm">
        <el-form-item label="アカウント" prop="email">
          <el-input v-model="data.body.user.email"></el-input>
        </el-form-item>
        <el-form-item label="パスワード" prop="password">
          <el-input type="password" autocomplete="off" show-password v-model="data.body.user.password"></el-input>
        </el-form-item>
        <el-form-item>
          <el-checkbox label="RememberMe" name="type"></el-checkbox>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="Login()">ログイン</el-button>
        </el-form-item>
      </el-form>

      <div class="clearfix align-center">
        <router-link to="/auth/sign_up">会員登録</router-link>
        <router-link to="/auth/forget_password">パスワード忘れ</router-link>
      </div>
    </div>
  </el-card>
</template>

<script>
export default {
  data() {
    return {
      data: {
        body: {
          user: {
            email: 'yanagi.yoshio@creatorslab.jp',
            password: 'test0123'
          }
        },
        rememberMe: true
      },
      rules: {
        email: [
          { required: true, message: 'Account is required', trigger: 'blur' },
          { type: 'email', message: 'Account is not a valid email', trigger: ['blur', 'change'] }
        ],
        password: [
          { required: true, message: 'Password is required', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    Login () {
      this.$auth.login({
        data: this.data.body,
        rememberMe: this.data.rememberMe
      }).then((res) => {
        console.log('success ' + res)
      }).catch(error => {
        console.log('error ' + res)
      })
    },
  },
  mounted () {
    // 待確認
    this.$auth.redirect()
  }
}
</script>

