<template>
  <div>
    <card class='stripe-card'
      :class='{ complete }'
      :stripe='stripe_key'
      :options='stripeOptions'
      @change='complete = $event.complete'
    />
    <button class='pay-with-stripe' @click='pay' :disabled='!complete'>登録</button>
  </div>
</template>

<script>
import { Card, createToken } from 'vue-stripe-elements-plus'

export default {
  data () {
    return {
      // stripe
      complete: false,
      stripe_key: '',
      stripeOptions: {
      },
    }
  },

  components: { Card },

  methods: {
    pay () {
      createToken().then(
        // tokenを得る   
        data => console.log('ok', data.token)
      )
    },
    // 環境URLにより、keyの取得が変わる
    env () {
      this.stripe_key = (window.location.hostname === 'vamos3.jp') ? '本番' : 'pk_test_6PxlCtpTt4jdcV2Xml8aOVAC00Ocm5Hq6x'
    }
  },
  mounted () {
    this.env()
  }
}
</script>

<style>
.stripe-card {
  width: 300px;
  border: 1px solid grey;
}
.stripe-card.complete {
  border-color: green;
}
</style>