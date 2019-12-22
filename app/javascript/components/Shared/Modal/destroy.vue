<template>
	<el-dialog title="削除" :visible.sync="dialogStatus" :before-close="toggleModal">
	  <span>{{destroyData.message}}</span>
	  <span slot="footer" class="dialog-footer">
	    <el-button @click="toggleModal">キャンセル</el-button>
	    <el-button type="primary" @click="Confrim">確認</el-button>
	  </span>
	</el-dialog>
</template>

<script>
  export default {
    props: {
      dialogStatus: Boolean,
      toggleModal: Function,
      destroyData: Object,
      init: Function
    },
    methods: {
      Confrim() {
        this.axios.delete(this.destroyData.url)
        .then(res => {

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
        .catch(error => {
        	// Modal close
	    	this.toggleModal()
	    	// Alert
	    	this.$message({
	    	  message: res.data.message,
	    	  type: res.data.status
	    	})
        })
      }
    }
  }
</script>