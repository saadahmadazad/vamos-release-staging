<template>
  <el-form  status-icon ref="ruleForm2" label-width="100px" class="demo-ruleForm">
    <el-form-item label="Account" prop="account">
      <el-input v-model="data.account"></el-input>
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="submitForm('ruleForm2')">Confirm</el-button>
    </el-form-item>
  </el-form>
</template>

<script>
export default {
  data() {
    return {
      data: {
        account: '',
      }
    }
  },
  methods: {
    submitForm () {
      alert('submit')
    }
  }
}
</script>
