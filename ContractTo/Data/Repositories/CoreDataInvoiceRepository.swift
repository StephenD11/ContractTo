//
//  CoreDataInvoiceRepository.swift
//  ContractTo
//
//  Created by Stepan on 17.02.2026.
//
import CoreData

final class CoreDataInvoiceRepository: InvoiceRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createInvoice(for clientId: UUID, number: Int) throws {
        
        // MARK: Нахожу клиента
        let clientRequest: NSFetchRequest<CDClient> = CDClient.fetchRequest()
        clientRequest.predicate = NSPredicate(format: "id == %@", clientId as CVarArg)
        
        guard let cdClient = try context.fetch(clientRequest).first else {
            throw NSError(domain: "ClientNotFound", code: 404)
        }
        
        // MARK: Создаю новый CDInvoice
        let cdInvoice = CDInvoice(context: context)
        
        cdInvoice.id = UUID()
        cdInvoice.number = Int64(number)
        cdInvoice.issueDate = Date()
        cdInvoice.dueDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())
        cdInvoice.statusRaw = InvoiceStatus.draft.rawValue
        cdInvoice.currencyCode = "USD"
        
        // MARK: Устанавливаю relationship
        cdInvoice.client = cdClient
        
        try context.save()
        
    }
    
    func fetchInvoices() throws -> [Invoice] {
        
        let request: NSFetchRequest<CDInvoice> = CDInvoice.fetchRequest()

        let results = try context.fetch(request)
        
        return results.map { cd in
            Invoice(
                id: cd.id ?? UUID(),
                number: Int(cd.number),
                issueDate: cd.issueDate ?? Date(),
                dueDate: cd.dueDate ?? Date(),
                status: InvoiceStatus(rawValue: cd.statusRaw ?? "draft") ?? .draft,
                clientId: cd.client?.id ?? UUID()
            )
        }
    }
    
    func deleteInvoice(id : UUID) throws {
        let request: NSFetchRequest<CDInvoice> = CDInvoice.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let invoice = try context.fetch(request).first {
            context.delete(invoice)
            try context.save()
        }
    }
    
    func updateStatus(id: UUID, status: InvoiceStatus) throws {
        
        let request: NSFetchRequest<CDInvoice> = CDInvoice.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        guard let invoice = try context.fetch(request).first else {
            return
        }
        
        invoice.statusRaw = status.rawValue
        
        try context.save()
    }
    
    func addItem(to invoiceId: UUID, title: String, quantity: Double, unitPrice: Double) throws {
        
        let invoiceRequest: NSFetchRequest<CDInvoice> = CDInvoice.fetchRequest()
        invoiceRequest.predicate = NSPredicate(format: "id == %@", invoiceId as CVarArg)
        
        guard let cdInvoice = try context.fetch(invoiceRequest).first else {
            return
        }
        
        let cdItem = CDInvoiceItem(context: context)
        
        cdItem.id = UUID()
        cdItem.title = title
        cdItem.quantity = quantity
        cdItem.unitPrice = unitPrice
        cdItem.invoice = cdInvoice
        
        try context.save()
    }
    
    func fetchItems(for invoiceId: UUID) throws -> [InvoiceItem] {
        
        let request: NSFetchRequest<CDInvoiceItem> = CDInvoiceItem.fetchRequest()
        request.predicate = NSPredicate(format: "invoice.id == %@", invoiceId as CVarArg)
        
        let results = try context.fetch(request)
        
        return results.map { cd in InvoiceItem(
            id: cd.id ?? UUID(),
            title: cd.title ?? "",
            quantity: cd.quantity,
            unitPrice: cd.unitPrice
        )}
    }
    
}
