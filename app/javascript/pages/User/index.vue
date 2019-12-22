<template>
    <div>
        <!-- Alert Message -->
        <alert-message v-if="alert.type" :alert="alert" />
        <h1>会員管理</h1>
        <hr />
        <el-button class="button" type="primary" @click="update">編集</el-button>
        <table style="width: 100%;border-spacing: 0px;">
            <tr>
                <th>ユーザー名</th>
                <td>{{user.name}}</td>
            </tr>
            <tr>
                <th>登録メールアドレス</th>
                <td>{{user.email}}</td>
            </tr>
            <tr>
                <th>クレジットカード登録</th>
                <td>
                    <stripe />
                    <div v-if="billing_status == 0">
                        <el-tag type="info">未登録</el-tag>
                    </div>
                    <div v-else-if="billing_status==1">
                        <el-tag type="success">登録済</el-tag>
                    </div>
                    <!-- <div>※stripeでクレカ登録の有無は取れるか？</div> -->
                </td>
            </tr>
            <tr>
                <th>決済状況</th>
                <td>
                    <div v-if="billing_status==0">
                        <el-tag type="info">無料登録期間</el-tag>
                        <div>あと{{last_date}}日</div>
                    </div>
                </td>
            </tr>
        </table>
        <!-- 編集 -->
        <update-component :dialogStatus="dialogStatus" :toggleModal="toggleModal" :init="init" :user="user" />
    </div>
</template>

<script>
import moment from 'moment';
import AlertMessage from '@/components/Shared/Alert'
import UpdateComponent from '@/components/User/Modal/update.vue'
import Stripe from '@/components/User/stripe.vue'
var created_date = moment([2019, 5, 20]); //仮で日付入力
export default {
    components: {
        AlertMessage,
        UpdateComponent,
        Stripe
    },
    data() {
        return {
            mode: '',
            alert: {},
            user: {},
            billing_status: 0,
            created_at: created_date,
            edit: false,
            dialogStatus: false,
        }
    },
    methods: {
        toggleModal() {
            this.dialogStatus = !this.dialogStatus
        },
        // Read
        init() {
            this.axios.get('/api/v1/users/' + this.$auth.user().id)
                .then(res => {
                    this.user = res.data.user
                })
                .catch(error => {
                    this.alert = { type: error.status, message: error.message }
                })
        },
        // 新規 Create
        update() {
            this.toggleModal()
        }
    },
    computed: {
        last_date: function() {
            let days = moment(this.created_at).add(60, "days"); //60日後の日付
            return days.diff(moment(), 'days'); //後何日後？
        }
    },
    mounted() {
        this.init()
    }
}
</script>

<style>
th {
    text-align: left;
    width: 20%;
}

th,
td {
    padding: 20px;
    color: #909399;
    border-bottom: 1px solid #EBEEF5;
}

tr:nth-child(even) {
    background: #FAFAFA;
}

.sub-title {
    padding: 20px;
}
</style>