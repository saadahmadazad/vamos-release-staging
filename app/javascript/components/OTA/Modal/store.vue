<template>
  <el-dialog title="OTA連携" :visible.sync="dialogStatus" :before-close="toggleModal">
    <el-form :model="data" :rules="rules" ref="ruleForm">
      <el-form-item label="施設" :label-width="formLabelWidth" prop="facility_id">
        <el-select v-model="data.facility_id" placeholder="選択してください">
          <el-option
            v-for="item in options.facilities"
            :key="item.id"
            :label="item.name"
            :value="item.id">
          </el-option>

        </el-select>
      </el-form-item>
      <el-form-item label="OTA" :label-width="formLabelWidth" prop="provider">
        <el-select v-model="data.provider" placeholder="選択してください">
          <el-option
            v-for="item in options.provider"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="Name" :label-width="formLabelWidth" prop="name">
        <el-input v-model="data.name" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="アカウント" :label-width="formLabelWidth" prop="account">
        <el-input v-model="data.account" autocomplete="off"></el-input>
      </el-form-item>
      <el-form-item label="パスワード" :label-width="formLabelWidth" prop="password">
        <el-input v-model="data.password" autocomplete="off" show-password></el-input>
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
          provider: '',
          account: '',
          password: '',
          name: '',
          facility_id: ''
        },
        options: {
          provider: [{
            value: 'rakuten',
            label: '楽天'
          }, {
            value: 'booking',
            label: 'Booking'
          }],
          facilities: [],
          ota_rooms: [],
          status: [{
            value: '0',
            label: '0'
          }, {
            value: '1',
            label: '1'
          }, {
            value: '2',
            label: '2'
          }]
        },
        rules: {
          facility_id: [
            { required: true, message: '施設を入力してください。', trigger: 'change' }
          ],
          provider: [
            { required: true, message: 'OTAを入力してください。', trigger: 'change' }
          ],
          name: [
            { required: true, message: 'Nameを入力してください。', trigger: 'change' }
          ],
          account: [
            { required: true, message: 'アカウントを入力してください。', trigger: 'change' },
            { type: 'email', message: 'アカウント is not a valid email', trigger: ['blur', 'change'] }
          ],
          password: [
            { required: true, message: 'パスワードを入力してください。', trigger: 'change' }
          ],
        },
        formLabelWidth: '120px',
      }
    },
    methods: {
      initOption () {
        // 施設 data
        this.axios.get('/api/v1/facilities')
        .then(res => {
          this.options.facilities = res.data.facilities
        })
        .catch(error => {
          this.alert = { type: error.data.status, message: error.data.message }
        })
      },
      Create (formName) {
        // Validate data
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.axios.post('/api/v1/ota', {
              otum: this.data
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
        })
      },
      closeDialog (formName) {
        this.$refs[formName].resetFields()
        this.toggleModal()
      }
    },
    mounted () {
      this.initOption()
    }
  }
</script>