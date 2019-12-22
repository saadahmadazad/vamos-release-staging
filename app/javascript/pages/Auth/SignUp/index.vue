<template>
  <el-card class="box-card">
    <div slot="header" class="clearfix">
      <span>会員登録</span>
    </div>
    <div>
      <el-form  status-icon :model="data.body.user" :rules="rules" ref="validateForm" label-width="100px" class="demo-ruleForm">
        <el-form-item label="お名前" prop="name">
          <el-input v-model="data.body.user.name"></el-input>
        </el-form-item>
        <el-form-item label="アカウント" prop="email">
          <el-input v-model="data.body.user.email"></el-input>
        </el-form-item>
        <el-form-item label="パスワード" prop="password">
          <el-input type="password" autocomplete="off" show-password v-model="data.body.user.password"></el-input>
        </el-form-item>
        <el-form-item label="パスワード確認" prop="password_confirmation">
          <el-input type="password" autocomplete="off" show-password v-model="data.body.user.password_confirmation"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitForm('validateForm')">登録</el-button>
        </el-form-item>
      </el-form>

      <div class="clearfix align-center">
        <router-link to="/auth/sign_in">会員ログイン</router-link>
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
            email: '',
            password: '',
            password_confirmation: '',
            name: '',
            role: 1
          }
        }
      },
      rules: {
        name: [
          { required: true, message: 'name is required', trigger: 'blur' }
        ],
        email: [
          { required: true, message: 'Account is required', trigger: 'blur' },
          { type: 'email', message: 'Account is not a valid email', trigger: ['blur', 'change'] }
        ],
        password: [
          { required: true, message: 'password is required', trigger: 'change' }
        ],
        password_confirmation: [
          { required: true, message: 'password is required', trigger: 'change' }
        ],
      }
    }
  },
  methods: {
    submitForm (formName) {
      this.$refs[formName].validate((valid) => {
          if (valid) {
            this.axios.post('/api/v1/users', {
              user: this.data.body.user,
            }).then((res) => {
              this.$message({
                message: '会員登録完了',
                type: 'success'
              })
            }).catch(error => {
              this.$message.error('会員登録失敗', res);
            })
          } else {
            return false;
          }
      });
    },
    closeDialog (formName) {
      this.$refs[formName].resetFields();
    }
  }
}
</script>
