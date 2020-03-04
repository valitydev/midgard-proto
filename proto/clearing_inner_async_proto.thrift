namespace java com.rbkmoney.midgard
namespace erlang midgard

include "base.thrift"

/** Номер переданного пакета данных */
typedef i32 PackageNumber

/** Идентификатор переданного пакета данных */
typedef string PackageTagID

typedef string UploadID

/** Информация о сбойной транзакции */
struct FailureTransactionData {
    1: required string transaction_id
    2: required string comment
}

/** Ответ адаптера по клиринговому событию */
struct ClearingEventResponse {
    1: required base.ClearingID              clearing_id
    2: required base.ClearingEventState      clearing_state
    3: optional list<FailureTransactionData> failure_transactions
}

/** Мета на пакет клиринговых данных */
struct ClearingDataPackageTag {
    1: required PackageTagID  package_tag_id
    2: required PackageNumber package_number
}

/** Пакет клиринговых данных */
struct ClearingDataRequest {
    2: required base.ClearingID        clearing_id
    3: required PackageNumber          package_number
    4: required bool                   final_package
    5: required list<base.Transaction> transactions
}

struct ClearingDataResponse {
    1: required ClearingDataPackageTag clearing_data_package_tag
    2: optional list<base.Transaction> failure_transactions
}

/** Результат обращения к адаптеру */
struct ClearingAdapterResult {
    1: required base.Intent intent
}

exception ClearingAdapterException {}

/** Асинхронный интерфейс взаимодействия с клиринговым адаптером банка */
service ClearingAdapterAsync {

    /** Команда на запуск клирингового эвента на стороне адаптера */
    UploadID StartClearingEvent(1: base.ClearingID clearing_id)
        throws (1: ClearingAdapterException ex1)

    /** Отправка данных в клиринговый адаптер */
    ClearingAdapterResult SendClearingDataPackage(1: UploadID upload_id, 2: ClearingDataRequest clearing_data_request)
        throws (1: ClearingAdapterException ex1)

    /** Команда на завершение клирингового эвента на стороне адаптера */
    void CompleteClearingEvent(1: UploadID upload_id, 2: base.ClearingID clearing_id, 3: list<ClearingDataPackageTag> tags)
        throws (1: ClearingAdapterException ex1)

    /** Получение ответа по клиринговому эвенту от банка */
    ClearingEventResponse GetBankResponse(1: base.ClearingID clearing_id)
        throws (1: ClearingAdapterException ex1)
}

/** Асинхронный интерфейс взаимодействия с клиентом клиринга */
service ClearingClientAsync {

    /** Запрос к клиенту на обработку обратного вызова от адаптера */
    void ProcessClearingAdapterCallback(1: base.CallbackTag tag, 2: ClearingDataResponse clearing_data_response)
}
