 namespace :mailboxer do
 	task migrate: :environment do
 		User.all.each do |user|
 			user.dibs.each do |dib|
 				conv = Mailboxer::Conversation.where(:conversable_id => dib.id)[0]
                if conv
					(conv.receipts_for user).each do |receipt|
						user.alerts.create(
							dib_id: dib.id, 
							post_id: dib.post_id, 
							created_at: receipt.created_at,
							message: receipt.message.body,
							updated_at:receipt.updated_at,
							read: receipt.is_read,
							sender_id: receipt.message.sender.id
						)
					end
 				end
 			end
 		end
 	end
 end