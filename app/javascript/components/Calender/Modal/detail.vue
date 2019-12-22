<template>
  <el-dialog title="予約詳細" :visible.sync="dialogStatus" :before-close="toggleModal">
    <!-- detail -->
    <table style="width: 100%;border-spacing: 0px;">
    <tr>
    <th>宿泊者名</th><td>{{detail.guest_name}}({{detail.guest_kana}})</td>
    </tr><tr>
    <th>代表者名</th><td>{{detail.subscriber_name}}({{detail.subscriber_kana}})</td>
    </tr><tr>
    <th>代表者連絡先</th><td>{{detail.subscriber_tel}}</td>
    </tr><tr>
    <th>代表者メール</th><td>{{detail.subscriber_email}}</td>
    </tr><tr>
    <th>代表者住所</th><td>{{detail.subscriber_address}}</td>
    </tr><tr>
    <th>予約日</th><td>{{detail.booking_date}}</td>
    </tr><tr>
    <th>更新日</th><td>{{detail.updated_at}}</td>
    </tr><tr>
    <th>チェックイン</th><td>{{detail.checkin}}</td>
    </tr><tr>
    <th>チェックアウト</th><td>{{detail.checkout}}</td>
    </tr><tr>
    <th>部屋数</th><td>{{detail.count_room}}</td>
    </tr><tr>
    <th>宿泊人数</th><td>{{detail.number_total}}人 男({{detail.number_male}}) 女({{detail.number_female}}) 大人({{detail.number_adluts}}) 子供({{detail.number_children}})</td>
    </tr><tr>
    <th>部屋料金</th><td>{{detail.price}}</td>
    </tr><tr>
    <th>支払い方法</th><td>{{detail.payment_method}}</td>
    </tr><tr>
    <th>現地精算額</th><td>{{detail.price_balance}}</td>
    </tr><tr>
    <th>支払い合計</th><td>{{detail.price_total}}</td>
    </tr>
    </table>
    <!-- form -->
    <el-form :model="data">
      <el-form-item label="備考">
        <el-input v-model="data.comment" type="textarea" :rows="2" placeholder="Please input">
        </el-input>
      </el-form-item>
    </el-form>
    <div slot="footer" class="dialog-footer">
      <el-button @click="toggleModal">キャンセル</el-button>
      <el-button type="primary">確認</el-button>
    </div>
  </el-dialog>
</template>

<style>
th{
  text-align: left;
  width: 20%;
}
th,td{
  padding:20px;
  color: #909399;
  border-bottom: 1px solid #EBEEF5;
}
tr:nth-child(even) {
  background: #FAFAFA;
}

.sub-title{
  padding:20px;
}
</style>

<script>
export default {
  props: {
    dialogStatus: Boolean,
    toggleModal: Function,
    detail: Object
  },
  data() {
    return {
      data: {
        comment:'テキスト'
      }
    }
  }
};
</script>
