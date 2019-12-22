<template>
	<el-dialog title="編集" :visible.sync="dialogStatus" :before-close="toggleModal">
		{{updateData}}
	  <el-form :model="data">
	  	<template v-for="(u, key) in updateData.data">
	  	  <el-form-item :label="u.label">
		  	<el-input v-if="u.type === 'input'"
		  			  v-model="data[u.name]" :value="ssss">
		 	</el-input>
		  </el-form-item>
		</template>
	  </el-form>
	  <span slot="footer" class="dialog-footer">
	    <el-button @click="toggleModal">キャンセル</el-button>
	    <el-button type="primary" @click="Confrim">修正</el-button>
	  </span>
	</el-dialog>
</template>

<script>
  export default {
    props: {
      dialogStatus: Boolean,
      toggleModal: Function,
      updateData: Object,
      init: Function
    },
    data() {
      return {
        data: {}
      }
    },
    methods: {
      Confrim() {
        this.axios.put(this.updateData.url, this.data).then(res => {
	    	// Clear data
	    	this.data = {}
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
        .catch(res => {
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