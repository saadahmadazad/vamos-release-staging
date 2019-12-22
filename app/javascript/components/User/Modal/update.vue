<template>
  <el-dialog title="会員編集" :visible.sync="dialogStatus" :before-close="toggleModal">
    <el-form :model="data" :rules="rules" ref="ruleForm">
      <el-form-item label="ユーザー名" prop="name">
        <el-input v-model="data.name" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="登録メールアドレス" prop="email">
        <el-input v-model="data.email" autocomplete="off"></el-input>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="closeDialog('ruleForm')">キャンセル</el-button>
      <el-button type="primary" @click="update('ruleForm')">修正</el-button>
    </div>
  </el-dialog>
</template>

<script>
  export default {
    props: {
      dialogStatus: Boolean,
      toggleModal: Function,
      init: Function
    },
    data() {
      return {
        data: {
          email: this.$auth.user().email,
          name: this.$auth.user().name,
        },
        rules: {
          name: [
            { required: true, message: '請輸入ユーザー名', trigger: 'change' }
          ],
          email: [
            { required: true, message: '請輸入メールアドレス', trigger: 'change' }
          ]
        }
      }
    },
    methods: {
      update (formName) {
        // Validate data
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.axios.put('/api/v1/users/' + this.$auth.user().id, {
              user: this.data
            })
            .then(res => {
              // Modal close
              this.toggleModal()
              // Alert
              this.$message({
                message: 'ok',
                type: res.data.status
              })
              // update
              this.init()
            })
            .catch(res => {
              // Modal close
              this.toggleModal()
              // Alert
              this.$message({
                message: res.data.message,
                type: res.data.status
              })
            })
          } else {
            return false
          }
        })
      },
      closeDialog (formName) {
        this.$refs[formName].resetFields()
        this.toggleModal()
      }
    }
  }
</script>