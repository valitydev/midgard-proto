namespace java com.rbkmoney.midgard
namespace erlang midgard

/**
 * Отметка во времени согласно RFC 3339.
 *
 * Строка должна содержать дату и время в UTC в следующем формате:
 * `2016-03-22T06:12:27Z`.
 */
typedef string Timestamp
/** ID события на стороне сервиса клиринга */
typedef i64 ClearingID
/** Сумма транзакции */
typedef i64 TransactionAmount
/** MCC */
typedef i32 MCC

/** Набор данных, подлежащий интерпретации согласно типу содержимого. */
struct Content {
    /** Тип содержимого, согласно [RFC2046](https://www.ietf.org/rfc/rfc2046) */
    1: required string type
    2: required binary data
}

/** Состояние клирингового события */
enum ClearingEventState {
    /** Клиринговое событие создано */
    CREATED
    /** Клиринговое событие запущено */
    EXECUTE
    /** Клиринговое событие успешно выполнено */
    SUCCESS
    /** Ошибка при выполнении клирингового события */
    FAILED
}

/** Основная информация о транзакции */
struct GeneralTransactionInfo {
    1: required string             transaction_id
    2: required Timestamp          transaction_date
    3: required TransactionAmount  transaction_amount
    4: required string             transaction_currency
    5: optional string             transaction_type
    6: optional MCC                mcc
    7: required string             invoice_id
    8: required string             payment_id
    9: optional string             refund_id
}

/** Карточные данные в рамках трназакции */
struct TransactionCardInfo {
    1: required string payer_bank_card_token
    2: optional string payer_bank_card_payment_system
    3: optional string payer_bank_card_bin
    4: optional string payer_bank_card_masked_pan
    5: optional string payer_bank_card_token_provider
}

/** Тип аккаунта */
enum CashFlowAccountType {
    merchant
    provider
    system
    external
    wallet
}

/** Тип инициатора движения денежных потоков для транзакции */
enum CashFlowChangeType {
    payment
    refund
    adjustment
    payout
}

/** Описание движения денежных потоков для транзакции */
struct TransactionCashFlow {
    1: required CashFlowChangeType    obj_type
    2: required CashFlowAccountType   source_account_type
    3: required string                source_account_type_value
    4: required i64                   source_account_id
    5: required CashFlowAccountType   destination_account_type
    6: required string                destination_account_type_value
    7: required i64                   destination_account_id
    8: required i64                   amount
    9: required string                currency_code
    10: optional string               details
}

/** Описание сущности "Транзакция" */
struct Transaction {
    1: required GeneralTransactionInfo       general_transaction_info
    2: optional TransactionCardInfo          transaction_card_info
    3: required list<TransactionCashFlow>    transaction_cash_flow
    4: optional Content                      additional_transaction_data
    5: optional string                       comment
}
