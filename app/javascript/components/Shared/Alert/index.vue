<template>
	<el-alert
		:title="alert.message"
		:type="alert.type"
		center
		show-icon>
	</el-alert>
</template>

<script>
  export default {
    props: {
      alert: Object
    }
  }
</script>