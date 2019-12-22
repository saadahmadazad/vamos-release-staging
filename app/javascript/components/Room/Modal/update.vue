<template>
  <el-dialog title="部屋新規" :visible.sync="dialogStatus" :before-close="toggleModal">
    <el-form :model="data" :rules="rules" ref="ruleForm">
      <el-form-item label="施設" :label-width="formLabelWidth" prop="facility_id">
        <el-select v-model="data.facility_id" placeholder="選択してください" @change="Onchange()" style="width: 180px">
          <el-option
            v-for="item in facilities"
            :key="item.id"
            :label="item.name"
            :value="item.id">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="OTA部屋" :label-width="formLabelWidth" prop="ota_rooms">
        <el-select v-model="data.ota_rooms" multiple placeholder="選択してください" style="width: 180px">
          <el-option
            v-for="item in options.ota_rooms"
            :key="item.id"
            :label="item.uid"
            :value="item.id">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="部屋名" :label-width="formLabelWidth" prop="name">
        <el-input v-model="data.name" autocomplete="off" style="width: 180px"></el-input>
      </el-form-item>
      <el-form-item label="部屋数" :label-width="formLabelWidth" prop="stock_max">
        <el-input-number v-model="data.stock_max" :min="1" :max="999"></el-input-number>
        <!-- <el-input v-model="data.stock_max" autocomplete="off"></el-input> -->
      </el-form-item>
      <el-form-item label="OB最大数" :label-width="formLabelWidth" prop="overbooking_thresh">
        <el-input-number v-model="data.overbooking_thresh" :min="1" :max="999"></el-input-number>
        <!-- <el-input v-model="data.overbooking_thresh" autocomplete="off"></el-input> -->
      </el-form-item>
      <el-form-item label="料金" :label-width="formLabelWidth" prop="price">
        <el-input-number v-model="data.price" :min="1"></el-input-number>
      </el-form-item>
      <el-form-item label="状態" :label-width="formLabelWidth" prop="status">
        <el-select v-model="data.status" placeholder="選択してください" style="width: 180px">
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
      <el-button type="primary" @click="Create('ruleForm')">新規</el-button>
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
          name: this.updateData.name,
          stock_max: this.updateData.stock_max,
          overbooking_thresh: this.updateData.overbooking_thresh,
          price: this.updateData.price,
          status: this.updateData.status,
          facility_id: this.updateData.facility_id
        },
        formLabelWidth: '120px',
        facilities: [],
        options: {
          status: [
            {
              value: 1,
              label: '公開'
            }, {
              value: 0,
              label: '不公開'
            }
          ],
          ota_rooms: [],
        },
        rules: {
          facility_id: [
            { required: true, message: '施設を入力してください。', trigger: 'change' }
          ],
          ota_rooms: [
            { required: true, message: 'OTA部屋を入力してください。', trigger: 'blur' }
          ],
          name: [
            { required: true, message: '部屋名を入力してください。', trigger: 'change' }
          ],
          stock_max: [
            { required: true, message: '部屋数を入力してください。', trigger: 'change' }
          ],
          overbooking_thresh: [
            { required: true, message: 'OB最大数を入力してください。', trigger: 'change' }
          ],
          price: [
            { required: true, message: '料金を入力してください。', trigger: ['change', 'blur'] },
            { type: 'number', message: '料金は数値でなければなりません'}
          ],
          status: [
            { required: true, message: 'パスワードを入力してください。', trigger: 'change' }
          ],
        }
      }
    },
    methods: {
      initOption () {
        //  施設 data && 施設 OTA 部屋 Optionデーターを取り出す
        this.axios.all([this.axios.get('/api/v1/facilities'), this.axios.get('/api/v1/ota/?facility=' + this.data.facility_id)])
        .then(this.axios.spread((res1, res2)=>{
          this.facilities = res1.data.facilities
          this.options.ota_rooms = res2.data.ota[0].ota_rooms
        }))
        .catch(error => {
          this.alert = { type: error.status, message: error.message }
        })
      },
      Create (formName) {
        // Validate data
        this.$refs[formName].validate((valid) => {
          if (valid) {
            this.axios.put('/api/v1/rooms/' + this.updateData.id, {
              room: this.data
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
            .catch(error => {
              // Modal close
              this.toggleModal()
              // Alert
              this.$message({
                message: res.data.message,
                type: res.data.status
              })
              // update
              this.init()
            })
          } else {
            return false
          }
        })
      },
      Onchange () {
        // clear ota_rooms
        this.options.ota_rooms = []

        // OTA部屋 data
        this.axios.get('/api/v1/ota/?facility=' + this.data.facility_id)
        .then(res => {
          this.options.ota_rooms = res.data.ota[0].ota_rooms
        })
        .catch(error => {
          this.alert = { type: error.status, message: error.message }
        })

        // OTA部屋 data
        // this.axios.get('/api/v1/ota_rooms?ota=' + this.ota.id)
        // .then(res => {
        //   this.options.ota_rooms = res.data.ota_rooms
        // })
        // .catch(error => {
        //   this.alert = { type: error.data.status, message: error.data.message }
        // })
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