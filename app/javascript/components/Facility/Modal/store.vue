<template>
  <el-dialog title="施設新規" :visible.sync="dialogStatus" :before-close="toggleModal">
    <el-form :model="data" :rules="rules" ref="ruleForm">
      <el-form-item label="施設名" prop="name">
        <el-input v-model="data.name" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="施設場所" prop="location">
        <el-input v-model="data.location" autocomplete="off"></el-input>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="closeDialog('ruleForm')">キャンセル</el-button>
      <el-button type="primary" @click="Create('ruleForm')">新規</el-button>
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
          name: '',
          location: '',
          user_id: this.$auth.user().id
        },
        rules: {
          name: [
            { required: true, message: '施設名を入力してください。', trigger: 'change' }
          ],
          location: [
            { required: true, message: '施設場所を入力してください。', trigger: 'change' }
          ]
        }
      }
    },
    methods: {
      Create (formName) {
        // Validate data
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.axios.post('/api/v1/facilities', {
              facility: this.data
            })
            .then(res => {
              // Clear data
              this.data = {}
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
        });
      },
      closeDialog (formName) {
        this.$refs[formName].resetFields()
        this.toggleModal()
      }
    }
  }
</script>