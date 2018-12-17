namespace java com.rbkmoney.midgard
namespace erlang midgard

include "base.thrift"

/** Номер переданного пакета данных */
typedef i64 PackageNumber

/** Информация о сбойной транзации */
struct FailureTransactionData {
    1: required string                       transaction_id
    2: required string                       comment
}

/** Ответ адаптера по клиринговому событию */
struct ClearingEventResponse {
    1: required base.ClearingID              clearing_ig
    2: required base.ClearingEventState      clearing_state
    3: optional list<FailureTransactionData> failure_transactions
}

/** Пакет клиринговых данных */
struct ClearingDataPackage {
    2: required base.ClearingID              clearing_id
    3: required PackageNumber                package_number
    4: required bool                         final_package
    5: required list<base.Transaction>       transactions
    6: required list<base.Merchant>          merchants
}

exception ClearingAdapterException {}

/** Интерфейс взаимодействия с клиринговым адаптером банка */
service ClearingAdapter {
    /** Команда на запуск клирингового эвента на стороне адаптера */
    void StartClearingEvent(1: base.ClearingID clearing_id) throws(1: ClearingAdapterException ex1)
    /** Отправка данных в клиринговый адаптер */
    void SendClearingDataPackage(1: ClearingDataPackage clearing_data_package) throws (1: ClearingAdapterException ex1)
    /** Получение ответа по клиринговому эвенту от банка */
    ClearingEventResponse GetBankResponse(1: base.ClearingID clearing_id) throws(1: ClearingAdapterException ex1)
}