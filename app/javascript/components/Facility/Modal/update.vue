<template>
  <el-dialog title="施設編集" :visible.sync="dialogStatus" :before-close="toggleModal">
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
      <el-button type="primary" @click="update('ruleForm')">修正</el-button>
    </div>
  </el-dialog>
</template>

<script>
  export default {
    props: {
      dialogStatus: Boolean,
      toggleModal: Function,
      init: Function,
      updateData: Object
    },
    data() {
      return {
        data: {
          location: this.updateData.location,
          name: this.updateData.name,
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
            this.axios.put('/api/v1/facilities/' + this.updateData.id, {
              facility: this.data
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
        this.toggleModal()
      }
    }
  }
</script>