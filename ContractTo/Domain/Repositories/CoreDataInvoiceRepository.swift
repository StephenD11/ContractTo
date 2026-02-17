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
    
    func createInvoice(for clientId: UUID) throws {
        
        //Нахожу клиента
        let clientRequest: NSFetchRequest<CDClient> = CDClient.fetchRequest()
        clientRequest.predicate = NSPredicate(format: "id == %@", clientId as CVarArg)
        
        guard let cdClient = try context.fetch(clientRequest).first else {
            throw NSError(domain: "ClientNotFound", code: 404)
        }
        
        //Создаю новый CDInvoice
        let cdInvoice = CDInvoice(context: context)
        
        cdInvoice.id = UUID()
        cdInvoice.number = Int64(Date().timeIntervalSince1970)
        cdInvoice.issueDate = Date()
        cdInvoice.dueDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        cdInvoice.statusRaw = InvoiceStatus.draft.rawValue
        cdInvoice.currencyCode = "USD"
        
        // Устанавливаю relationship
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
}
