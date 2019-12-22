<template>
    <el-container>
        <FullCalendar
        	defaultView="timeGridWeek"
        	@dateClick="dateClick"
        	@eventClick="eventClick"
        	:locale = "locale"
        	:plugins="calendarPlugins"
        	:events="events"
        	:editable="true"
        	:selectable="true"
        	:ignoreTimezone="false"
        	:nowIndicator="true"
        	:header="header"
        	:eventLimit="true"
        	:firstDay="0"
        	:weekends="true"
        	weekMode="fixed"
        	:weekNumbers="false"
        	:slotDuration="slotDuration"
        	:snapDuration="snapDuration"
        	:allDaySlot="true"
        	allDayText="全日"
        	:slotMinutes="15"
        	:snapMinutes="15"
        	:slotLabelFormat="slotLabelFormat"
        	:firstHour="9"
        	:defaultTimedEventDuration="defaultTimedEventDuration"
        	:axisFormat="axisFormat"
        	:timeFormat="timeFormat"
        	:maxTime="maxTimes"
            :resourceGroupField="resourceGroupField"
            :resources="resources"
        	:minTime="minTimes"/>
            <!-- 在庫 -->
            <stock-modal v-if="mode === 'stock'"
                         :dialogStatus="dialogStatus"
                         :toggleModal="toggleModal"
                         :init="init"/>
            <!-- 詳細 -->
            <detail-modal v-if="mode === 'detail'"
                          :dialogStatus="dialogStatus"
                          :toggleModal="toggleModal"
                          :detail="detail"/>
    </el-container>
</template>

<script>
import FullCalendar from '@fullcalendar/vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import momentPlugin from '@fullcalendar/moment'
import timeGridPlugin from '@fullcalendar/timegrid'
import resourceTimeline from '@fullcalendar/resource-timeline'
import interactionPlugin from '@fullcalendar/interaction'
import jaLocale from '@fullcalendar/core/locales/ja'
import StockModal from '@/components/Calender/Modal/stock.vue'
import DetailModal from '@/components/Calender/Modal/detail.vue'
import moment from 'moment/moment'

export default {
    components: {
        FullCalendar,
        StockModal,
        DetailModal
    },
    props: {
        event: {
            type: Array,
            required: false
        }
    },
    data() {
        return {
            calendarPlugins: [
                dayGridPlugin,
                momentPlugin,
                timeGridPlugin,
                interactionPlugin,
                resourceTimeline
            ],
            locale: jaLocale,
            events: [],
            header: {
                left: 'today prev,next',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay,resourceTimeline'
            },
            slotDuration: '00:30:00',
            snapDuration: '00:15:00',
            slotLabelFormat: 'H:mm',
            defaultTimedEventDuration: '10:00:00',
            axisFormat: 'H:mm',
            timeFormat: 'H:mm',
            minTimes: '07:00',
            maxTimes: '19:00',
            buttonText: {
                prev: '',
                next: '',
                prevYear: '',
                nextYear: ''
            },
            resourceGroupField: 'building',
            resources: [
              { id: 'a', building: '難波ホテル', title: '3人部屋' },
              { id: 'b', building: '無料ホテル', title: '4人部屋' },
            ],
            dialogStatus: false,
            mode: '',
            detail: {}
        }
    },
    methods: {
        toggleModal () {
          this.dialogStatus = !this.dialogStatus
        },
        init () {
          this.axios.get('/api/v1/bookings')
          .then(res => {
            this.bookings = res.data.bookings
            this.bookings.forEach(value => {
                if (value.is_blocked) {

                   this.events.push({
                       id: value.id,
                       start: moment(value.checkin).format("YYYY-MM-DD"),
                       end: moment(value.checkout).format("YYYY-MM-DD"),
                       title: value.room.name,
                       className: "block_event",
                       extendedProps: {type:'block'}
                   })
                } else{
                   if (value.otum.provider === "rakuten") {
                     this.events.push({
                         id: value.id,
                         start: moment(value.checkin).format("YYYY-MM-DD"),
                         end: moment(value.checkout).format("YYYY-MM-DD"),
                         title: value.room.name,
                         className: "rakuten_event",
                         extendedProps: {type:'rakuten'}
                     })
                   } else if (value.otum.provider === "booking") {
                     this.events.push({
                         id: value.id,
                         start: moment(value.checkin).format("YYYY-MM-DD"),
                         end: moment(value.checkout).format("YYYY-MM-DD"),
                         title: value.room.name,
                         className: "booking_event",
                         extendedProps: {type:'bookign'}
                     })
                   }
                }
            })
          })
          .catch(error => {
            console.log('error')
            // this.alert = { type: error.data, message: error.data.message }
          })
        },
        eventClick(info) {
            this.mode = 'detail'
            this.detail = this.bookings.find((item, index, array) => {
                    return item.id == info.event.id
            })
            return (info.event.extendedProps.type !== 'block') ?
            this.toggleModal() : false
        },
        dateClick(info) {
            this.mode = 'stock'
            this.toggleModal()
        }
    },
    created () {
        this.init()
    }
}
</script>