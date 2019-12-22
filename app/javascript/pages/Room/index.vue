<template>
  <div>
    <!-- Alert Message -->
    <alert-message v-if="alert.type" :alert="alert" />
    <el-button type="primary" @click="store">新規</el-button>

    <!-- table -->
    <common-table
      :columns="columns"
      :dataSource="rooms"
      :options="options"
      :fetch="fetchTableData"
      :pagination="pagination"
      @row-click="handleRowClick"
      @selection-change="handleSelectionChange"
    />
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
import StoreModal from '@/components/Room/Modal/store.vue'
import UpdateModal from '@/components/Room/Modal/update.vue'
import DestroyModal from '@/components/Shared/Modal/destroy.vue'

  export default {
    components: {
      CommonTable,
      AlertMessage,
      StoreModal,
      UpdateModal,
      DestroyModal
    },
    data() {
      return {
        mode:'',
        alert: {},
        rooms: [],
        dialogStatus: false,
        columns: [
          {
            prop: 'name',
            label: '部屋名',
          },
          {
            prop: 'stock_max',
            label: '部屋数'
          },
          {
            prop: 'overbooking_thresh',
            label: 'OB最大数'
          },
          {
            prop: 'price',
            label: '料金'
          },
          {
            prop: 'status',
            label: '状態'
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
              name: '削除',
              type: 'danger',
              icon: 'el-icon-delete',
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
          initTable: true
        }
      }
    },
    methods: {
      toggleModal () {
        this.dialogStatus = !this.dialogStatus
      },
      fetchTableData() {
        this.options.loading = true
        this.axios.get('/api/v1/rooms/', {
          pageIndex: this.pagination.pageIndex,
          pageSize: this.pagination.pageSize
        }).then(res => {
          const { rooms, total } = res.data
          this.rooms = rooms
          this.pagination.total = total
          this.options.loading = false
        }).catch((error) => {
          this.options.loading = false
        })
      },
      // Read
      init () {
        this.axios.get('/api/v1/rooms')
        .then(res => {
          this.rooms = res.data.rooms
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
          url: '/api/v1/rooms/' + data.id,
          message: '部屋を削除しますか？'
        }
        this.toggleModal()
      },
      handleClick(e, row){
        e.cancelBubble = true
        console.log(row)
      },
      handleRowClick(row, event, column){
        console.log('click row:',row, event, column)
      },
      handleSelectionChange(selection){
        console.log(selection)
      },
      handleEdit(index, row) {
        console.log(index, row);
      },
      handleDelete(index, row) {
        console.log(index, row);
      }
    }
  }
</script>
