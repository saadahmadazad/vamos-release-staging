<template>
  <el-dialog title="在庫" :visible.sync="dialogStatus" :before-close="toggleModal">
    <el-form :model="data" :rules="rules" ref="ruleForm">
      <el-form-item label="部屋" :label-width="formLabelWidth" prop="room_id">
        <el-select v-model="data.room_id" placeholder="選択してください">
          <el-option
            v-for="item in options.rooms"
            :key="item.id"
            :label="item.name"
            :value="item.id">
          </el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="日付" :label-width="formLabelWidth" prop="date_range">
        <el-date-picker
          v-model="date_range"
          type="daterange"
          start-placeholder="Start"
          end-placeholder="End"
          :default-time="['00:00:00', '23:59:59']">
        </el-date-picker>
      </el-form-item>

      <el-form-item label="在庫数" :label-width="formLabelWidth" prop="count_room">
        <el-input type="number" v-model="data.count_room" autocomplete="off"></el-input>
      </el-form-item>

      <el-form-item label="状態" :label-width="formLabelWidth" prop="is_blocked">
        <el-select v-model="data.is_blocked" placeholder="選択してください">
          <el-option
            v-for="item in options.status"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="closeDialog('ruleForm')">キャンセル</el-button>
      <el-button type="primary" @click="Create('ruleForm')">保存</el-button>
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
          rooms: [],
          checkin: '',
          checkout: '',
          is_blocked: true
        },
        date_range: [],
        options:{
          rooms: []
        },
        options: {
          status: [
            {
              value: true,
              label: 'ブロック'
            }, {
              value: false,
              label: '予約可'
            }
          ],
          rooms: []
        },
        formLabelWidth: '120px',
        rules: {
          room_id: [
            { required: true, message: '部屋を入力してください。', trigger: 'change' }
          ],
          count_room: [
            { required: true, message: '在庫數を入力してください。', trigger: 'change' }
          ],
          is_blocked: [
            { required: true, message: '状態を入力してください。', trigger: 'change' },
          ]
        }
      }
    },
    methods: {
      initOption () {
        // 部屋 data
        this.axios.get('/api/v1/rooms')
        .then(res => {
          this.options.rooms = res.data.rooms
        })
        .catch(error => {
          this.alert = { type: error.data.status, message: error.data.message }
        })
      },
      Create (formName) {
        this.data.checkin = this.date_range[0]
        this.data.checkout = this.date_range[1]
        // Validate data
        this.$refs[formName].validate((valid) => {
          if (valid) {
            // api
            this.axios.post('/api/v1/bookings', {
              booking: this.data
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
              // // update
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
        this.date_range = []
        this.$refs[formName].resetFields()
        this.toggleModal()
      }
    },
    created () {
      this.initOption()
    }
  }
</script>