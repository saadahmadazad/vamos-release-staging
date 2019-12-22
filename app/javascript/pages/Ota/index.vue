<template>
    <div>
      <!-- Alert Message -->
      <alert-message v-if="alert.type" :alert="alert" />
      <el-button type="primary" @click="store">新規</el-button>
      <common-table
        :columns="columns"
        :dataSource="ota"
        :options="options"
        :fetch="fetchTableData"
        :pagination="pagination"
        @row-click="handleRowClick"
        @selection-change="handleSelectionChange"/>
      <!-- 新規 -->
      <store-modal v-if="mode === 'store'"
                      :dialogStatus="dialogStatus"
                      :toggleModal="toggleModal"
                      :init="init"/>
      <!-- 編集 -->
      <update-modal v-if="mode === 'update'"
                      :dialogStatus="dialogStatus"
                      :toggleModal="toggleModal"
                      :updateData="modalData"
                      :init="init"/>
      <!-- 削除 -->
      <destroy-modal v-if="mode === 'destroy'"
                      :dialogStatus="dialogStatus"
                      :toggleModal="toggleModal"
                      :destroyData="modalData"
                      :init="init"/>
    </div>
</template>

<script>
import AlertMessage from '@/components/Shared/Alert'
import CommonTable from '@/components/Shared/Table/index.vue'
import StoreModal from '@/components/OTA/Modal/store.vue'
import UpdateModal from '@/components/OTA/Modal/update.vue'
import DestroyModal from '@/components/Shared/Modal/destroy.vue'

export default{
  components:{
    CommonTable,
    AlertMessage,
    StoreModal,
    UpdateModal,
    DestroyModal
  },
  data(){
    return {
      mode:'',
      dialogStatus: false,
      ota: [],
      alert: {},
      columns: [
        {
          prop: 'facility_id',
          label: '施設'
        },
        {
          prop: 'provider',
          label: 'OTA',
        },
        {
          prop: 'status',
          label: '状態'
        },
        {
          prop: 'account',
          label: 'アカウント'
        },
        {
          button: true,
          label: 'Operations',
          group: [{
            name: '編集',
            type: 'warning',
            icon: 'el-icon-edit',
            plain: true,
            onClick: (row) => {
              this.update(row)
            }
          }, {
            name: '連携解除',
            type: 'danger',
            icon: 'fa fa-chain-broken',
            onClick: (row) => {
              this.destroy(row)
            }
          }]
        }
      ],
      pagination: {
        total: 0,
        pageIndex: 1,
        pageSize: 15
      },
      options: {
        mutiSelect: true,
        index: true,
        loading: false,
        initTable: true,
      }
    }
  },
  methods: {
    toggleModal () {
      this.dialogStatus = !this.dialogStatus
    },
    handleClick(e, row){
      e.cancelBubble = true
    },
    fetchTableData() {
       this.options.loading = true
       this.axios.get('/api/v1/ota/', {
        pageIndex: this.pagination.pageIndex,
        pageSize: this.pagination.pageSize
      }).then(res => {
        this.ota = res.data.ota
        this.pagination.total = total
        this.options.loading = false
      }).catch(error => {
        this.options.loading = false
        this.alert = { type: error.data.status, message: error.data.message }
      })
    },
    handleRowClick(row, event, column){
      console.log('click row:',row, event, column)
    },
    handleSelectionChange(selection){
      console.log(selection)
    },
    // Read
    init () {
      this.axios.get('/api/v1/ota')
      .then(res => {
        this.ota = res.data.ota
      })
      .catch(error => {
        this.alert = { type: res.data.status, message: res.data.message }
      })
    },
    // 新規 Create
    store () {
      this.mode = 'store'
      this.toggleModal()
    },
    // 編集 Update
    update (data) {
      this.mode = 'update'
      this.modalData = data
      this.toggleModal()
    },
    // 削除 Delete
    destroy (data) {
      this.mode = 'destroy'
      this.modalData = {
        url: '/api/v1/ota/' + data.id,
        message: 'OTAを削除しますか？'
      }
      this.toggleModal()
    }
  }
}
</script>